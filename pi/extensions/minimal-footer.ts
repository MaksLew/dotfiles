import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

const MODEL = "\x1b[38;2;243;139;168m"; // #f38ba8
const THINKING = "\x1b[38;2;250;179;135m"; // #fab387
const CONTEXT = "\x1b[38;2;249;226;175m"; // #f9e2af
const USAGE = "\x1b[38;2;166;227;161m"; // #a6e3a1
const RESET_FG = "\x1b[39m";
const USAGE_URL = "https://chatgpt.com/backend-api/wham/usage";

type UsageWindow = { used_percent?: number; limit_window_seconds?: number };
type UsageResponse = {
	rate_limits?: { rate_limit?: { primary_window?: UsageWindow; secondary_window?: UsageWindow } };
	rate_limit?: { primary_window?: UsageWindow; secondary_window?: UsageWindow };
};

function color(code: string, text: string): string {
	return `${code}${text}${RESET_FG}`;
}

function accountId(token: string): string | undefined {
	try {
		const payload = token.split(".")[1];
		if (!payload) return;
		const claim = JSON.parse(Buffer.from(payload, "base64url").toString());
		return claim["https://api.openai.com/auth"]?.chatgpt_account_id;
	} catch {
		return;
	}
}

export function formatUsage(data: UsageResponse): string | undefined {
	const limits = data.rate_limits?.rate_limit ?? data.rate_limit;
	const windows = [limits?.primary_window, limits?.secondary_window].filter(
		(window): window is UsageWindow => Number.isFinite(window?.used_percent),
	);
	if (!windows.length) return;

	return windows.map((window) => {
		const minutes = (window.limit_window_seconds ?? 0) / 60;
		const label = minutes === 300 ? "5h" : minutes === 10080 ? "weekly" : "usage";
		return `${label} ${Math.max(0, 100 - window.used_percent!).toFixed(0)}% left`;
	}).join(" / ");
}

export default function (pi: ExtensionAPI) {
	let refresh: (() => Promise<void>) | undefined;
	let stop = () => {};

	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;

		let subscriptionUsage: string | undefined;
		let requestRender = () => {};
		let inFlight = false;
		stop = () => {
			refresh = undefined;
			requestRender = () => {};
		};

		refresh = async () => {
			if (ctx.model?.provider !== "openai-codex" || inFlight) return;
			inFlight = true;
			try {
				const token = await ctx.modelRegistry.getApiKeyForProvider("openai-codex");
				const account = token && accountId(token);
				if (!token || !account) return;
				const response = await fetch(USAGE_URL, {
					headers: { Authorization: `Bearer ${token}`, "ChatGPT-Account-Id": account },
				});
				if (response.ok) subscriptionUsage = formatUsage(await response.json() as UsageResponse);
			} catch {
				// Keep the last good value; usage is optional footer data.
			} finally {
				inFlight = false;
				requestRender();
			}
		};

		ctx.ui.setFooter((tui) => {
			requestRender = () => tui.requestRender();
			return {
				invalidate() {},
				render(width: number): string[] {
					const model = ctx.model?.name ?? ctx.model?.id ?? "no model";
					const thinking = ctx.thinkingLevel ?? "off";
					const usage = ctx.getContextUsage();

					const context = usage?.percent === null || usage?.percent === undefined
						? "context unavailable"
						: `${usage.percent.toFixed(1)}% used`;

					const parts = [
						color(MODEL, model),
						color(THINKING, thinking),
						color(CONTEXT, context),
					];
					if (ctx.model?.provider === "openai-codex" && subscriptionUsage) {
						parts.push(color(USAGE, subscriptionUsage));
					}

					return [truncateToWidth(parts.join(" • "), width, "…")];
				},
			};
		});

		void refresh();
	});

	pi.on("agent_settled", () => refresh?.());
	pi.on("model_select", () => refresh?.());
	pi.on("session_shutdown", () => stop());
}
