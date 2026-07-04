// @ts-nocheck
/** @jsxImportSource @opentui/solid */
import type { TuiPlugin } from "@opencode-ai/plugin/tui"
import { useTerminalDimensions } from "@opentui/solid"
import { createMemo } from "solid-js"
import fs from "fs"
import path from "path"

const id = "gentle-logo"

const catArt = [
  "            .,.                             ..                  ",
  "            .dd.                           cx'                  ",
  "            .lxo,                        .cdd,                  ",
  "            .l:,o,                      'o:,o;                  ",
  "            .l; ,o,                    :o, .o,                  ",
  "            .l;  ;d,                 .lc.  'd,                  ",
  "            .o,   ..  .             .c,    .d;                  ",
  "            'o'    .;cc:c,..;:;::,.        .l:                  ",
  "            ;c.   :o:.  .ldxl. .';c;.       ll                  ",
  "           .c,   ;x,   .'.lO;     .c:       ..                  ",
  "           ..    lo.   :k'.lc ':;. 'o'                          ",
  "                .od.   ;o. ,c.;xd' .l:                          ",
  "                 :x,   ,o'.o; ,ol'  c:                          ",
  "    .;;.         .cd'  .xddO: 'od, .o,                          ",
  "   'll.            ,c::cdo:,;;cxOl:o:          .,::'            ",
  "  ,d:                 ..     .',;;;.  ':.        .,cc:'         ",
  " ,o;              .'                 ;Ok.           .,cc,.      ",
  ",xd;cl.           cOl.             'loxk'              .:l;     ",
  ".'.'oc            ;Odol:'.....',,:lo;.;x,          .,,,...:l,   ",
  "  ,xk:',.         ,d' ,xx::dd:;cdo;   :x'          'dOxl:;,lko. ",
  " c00ddOx.         .d; .c,  ;l. .l:.   lx.            ,lc. ..;od;",
  ".::..cl.           lo..c,  'c. .:c'  ,Ox.              ;o:.   ..",
  "   .lo.            ;Oo;dc  .c. .'cc,cdOl                .cl,    ",
  "   co.             .dolOk:,lOdcodkkl''o:         'c:;;::;,:dl.  ",
  "  ;x,               cd..oc,ldc,cdo.  :o.         .cc,...',;cxd. ",
  " .xd. .;ll'         .ol.;' ,c. 'll. .o:            .,,.     .:, ",
  " 'OOlccc;.           .ldd; :d. .cd; :l.              .:;.       ",
  " .kO;.                .dKo.,d, .'oxl:.                .:o,      ",
  "  ..                   .,lloOx;;cdd,         .llc:::,'',ok:     ",
  "                          .,:c:;,.            ....    ...'.     ",
]

const compactArt = ["✦ Catppuccin ✦"]

// Load custom ASCII art from external file if it exists
let customArt: string[] | null = null
try {
  let logoPath = ""
  const home = process.env.USERPROFILE || process.env.HOME || ""
  const globalConfigLogo = path.join(home, ".config", "opencode", "tui-plugins", "logo.txt")

  if (fs.existsSync(globalConfigLogo)) {
    logoPath = globalConfigLogo
  } else {
    try {
      const localLogo = path.join(__dirname, "logo.txt")
      if (fs.existsSync(localLogo)) {
        logoPath = localLogo
      }
    } catch (err) {
      try {
        const { fileURLToPath } = require("url")
        const metaUrl = eval("import.meta.url")
        const localLogo = path.join(path.dirname(fileURLToPath(metaUrl)), "logo.txt")
        if (fs.existsSync(localLogo)) {
          logoPath = localLogo
        }
      } catch (e) {}
    }
  }

  if (logoPath && fs.existsSync(logoPath)) {
    const content = fs.readFileSync(logoPath, "utf8")
    customArt = content.split(/\r?\n/)
  }
} catch (e) {
  // Fallback to default
}

const Logo = () => {
  const dim = useTerminalDimensions()
  const lines = createMemo(() => {
    const term = dim()
    const art = customArt || catArt
    return term.height >= art.length + 6 && term.width >= 64 ? art : compactArt
  })

  return (
    <box flexDirection="column" alignItems="center">
      {lines().map((line) => (
        <text fg="#00FF00">{line}</text>
      ))}
    </box>
  )
}

const tui: TuiPlugin = async (api) => {
  api.slots.register({
    id,
    order: 100,
    slots: {
      home_logo() {
        return <Logo />
      },
    },
  })
}

const plugin = { id: "gentle-logo", tui }
export default plugin
