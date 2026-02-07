#!/etc/profiles/per-user/shuntaka/bin/deno run --allow-read --allow-env

interface Profile {
  name: string
  requiresMfa: boolean
  region: string | null
}

const main = () => {
  try {
    const homeDir = Deno.env.get("HOME")
    if (!homeDir) {
      console.log(JSON.stringify({ success: false, error: "HOME environment variable is not set" }))
      Deno.exit(1)
    }

    const configPath = `${homeDir}/.aws/config`
    let content: string
    try {
      content = Deno.readTextFileSync(configPath)
    } catch {
      console.log(JSON.stringify({ success: false, error: `Cannot read ${configPath}` }))
      Deno.exit(1)
    }

    const profiles: Profile[] = []
    let currentProfile: string | null = null
    let currentRegion: string | null = null
    let currentRequiresMfa = false

    const flushProfile = () => {
      if (currentProfile !== null) {
        profiles.push({
          name: currentProfile,
          requiresMfa: currentRequiresMfa,
          region: currentRegion,
        })
      }
    }

    for (const line of content.split("\n")) {
      const trimmed = line.trim()

      const profileMatch = trimmed.match(/^\[profile\s+(.+)\]$/)
      if (profileMatch) {
        flushProfile()
        currentProfile = profileMatch[1]
        currentRegion = null
        currentRequiresMfa = false
        continue
      }

      // Skip default profile header or other section headers
      if (trimmed.startsWith("[")) {
        flushProfile()
        currentProfile = null
        currentRegion = null
        currentRequiresMfa = false
        continue
      }

      if (currentProfile === null) continue

      const kvMatch = trimmed.match(/^([^=]+?)\s*=\s*(.+)$/)
      if (!kvMatch) continue

      const key = kvMatch[1].trim()
      const value = kvMatch[2].trim()

      if (key === "region") {
        currentRegion = value
      } else if (key === "mfa_serial") {
        currentRequiresMfa = true
      }
    }

    flushProfile()

    console.log(JSON.stringify({ profiles }, null, 2))
  } catch (error) {
    console.log(JSON.stringify({ success: false, error: `Unexpected error: ${error}` }))
    Deno.exit(1)
  }
}

main()
