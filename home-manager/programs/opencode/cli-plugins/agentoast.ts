import { execFile } from "node:child_process"

// TUI プロセス内で動く CLI プラグイン。
// 共有サーバー側で動くプラグインからは TMUX_PANE が取れないため、通知は TUI 側から送る。

type OpenCodeEvent = {
  type: string
  data?: { sessionID?: string } & Record<string, unknown>
  location?: { directory: string }
}

type Context = {
  location: { directory: string } | undefined
  data: {
    listen(handler: (event: { details: OpenCodeEvent }) => void): () => void
    session: {
      root(sessionID: string): string
      get(sessionID: string): { location?: { directory?: string } } | undefined
    }
  }
  ui: {
    router: { current(): { type: string; sessionID?: string } }
    tabs: { enabled(): boolean; list(): readonly { sessionID: string }[] }
  }
}

// agentoast hook opencode が扱う V1 イベント名へ変換する
const AGENTOAST_EVENTS: Record<string, string> = {
  "session.status": "session.status",
  "session.execution.failed": "session.error",
  "permission.asked": "permission.asked",
}

export default {
  id: "agentoast.notify",
  setup(context: Context) {
    // 共有サーバーのイベントは全 TUI に届くため、この TUI で開いたルートセッションだけを通知対象にする
    const ownedRoots = new Set<string>()
    const trackOwnedSessions = () => {
      const route = context.ui.router.current()
      if (route.type === "session" && route.sessionID) {
        ownedRoots.add(context.data.session.root(route.sessionID))
      }
      if (context.ui.tabs.enabled()) {
        for (const tab of context.ui.tabs.list()) ownedRoots.add(tab.sessionID)
      }
    }

    return context.data.listen(({ details: event }) => {
      trackOwnedSessions()

      const type = AGENTOAST_EVENTS[event.type]
      const sessionID = event.data?.sessionID
      if (!type || !sessionID) return

      const rootID = context.data.session.root(sessionID)
      if (!ownedRoots.has(rootID)) return
      // サブエージェントの完了では通知しない
      if (event.type === "session.status" && sessionID !== rootID) return

      const directory =
        context.data.session.get(rootID)?.location?.directory ??
        event.location?.directory ??
        context.location?.directory
      const payload = JSON.stringify({ type, properties: event.data, directory })

      execFile("agentoast", ["hook", "opencode", payload], () => {})
    })
  },
}
