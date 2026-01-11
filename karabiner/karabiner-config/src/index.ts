import {
  ifApp,
  map,
  rule,
  to$,
  withCondition,
  writeToProfile,
} from "karabiner.ts";
import {
  createLayer,
  doubleTap,
  ifLayer,
  mapToLink,
  rectangle,
  toFocusApp,
} from "./utils";
import { createVimLayer } from "./vim-layer";

const applicationManipulators = [
  map("h").to(toFocusApp("Obsidian")),
  map("j").to(toFocusApp("Google Chrome")),
  map("k").to(toFocusApp("Ghostty")),
  doubleTap("l")
    .to(toFocusApp("Cursor"))
    .singleTap(toFocusApp("Visual Studio Code")),
  map(";").to(toFocusApp("Slack")),

  map("o").toAfterKeyUp([
    {
      key_code: "tab",
      modifiers: ["right_command"],
      hold_down_milliseconds: 20,
    },
    { key_code: "vk_none" },
  ]),
  map("i").toAfterKeyUp([
    {
      key_code: "grave_accent_and_tilde",
      modifiers: ["right_command"],
      hold_down_milliseconds: 20,
    },
    { key_code: "vk_none" },
  ]),

  mapToLink("g", "https://calendar.google.com"),
  mapToLink("e", "https://mail.google.com/"),
  mapToLink("m", "https://open.spotify.com"),
  mapToLink("n", "https://www.notion.so"),
  mapToLink("y", "https://www.youtube.com"),
  mapToLink(
    "t",
    "https://www.google.com/search?q=stopwatch",
    "https://www.google.com/search?q=timer"
  ),
  map("b").to$(
    "open -g raycast://extensions/Codely/google-chrome/search-bookmarks"
  ),
  mapToLink("'", "https://claude.ai"),

  doubleTap("p")
    .to(
      to$("open raycast://extensions/degouville/cursor-recent-projects/index")
    )
    .singleTap(
      to$("open raycast://extensions/thomas/visual-studio-code/index")
    ),
];

const finderLayer = [
  map("j").to({ key_code: "tab", modifiers: ["right_command"] }),
  map("k").to({ key_code: "left_shift", modifiers: ["right_command"] }),

  map("h").to({ key_code: "left_shift", modifiers: ["right_command"] }),
  map("l").to({
    key_code: "grave_accent_and_tilde",
    modifiers: ["right_command"],
  }),

  map("o").toAfterKeyUp([
    {
      key_code: "tab",
      modifiers: ["right_command"],
      hold_down_milliseconds: 0,
    },
    { key_code: "vk_none" },
  ]),
  map("i").toAfterKeyUp([
    {
      key_code: "grave_accent_and_tilde",
      modifiers: ["right_command"],
      hold_down_milliseconds: 0,
    },
    { key_code: "vk_none" },
  ]),

  doubleTap("u")
    .to({
      key_code: "q",
      modifiers: ["right_command"],
    })
    .singleTap({
      key_code: "w",
      modifiers: ["right_command"],
    }),
  map("right_shift").to({
    key_code: "escape",
    modifiers: ["right_command"],
  }),
];

const rules = [
  rule("Tap Caps Lock for ESC or Hold for Control").manipulators([
    map("caps_lock", null, "any")
      .to([{ key_code: "left_control", lazy: true }])
      .toIfAlone("escape"),
  ]),

  rule("Hold ; for Control").manipulators(
    withCondition(ifLayer().unless())([
      map(";", "control", undefined).toIfAlone({
        key_code: "spacebar",
        modifiers: ["left_command"],
      }),
      map(";", "optionalAny")
        .toIfAlone(";", undefined, { halt: true })
        .toIfHeldDown("right_control", undefined, {})
        .parameters({
          "basic.to_if_held_down_threshold_milliseconds": 50,
        }),
    ])
  ),

  ...(["e"] as const).map((key) =>
    createLayer(key).manipulators(applicationManipulators)
  ),

  createLayer("r").manipulators([
    rectangle("j", "bottom-half"),
    rectangle("k", "top-half"),
    rectangle("h", "left-half"),
    rectangle("l", "right-half"),
    rectangle("return_or_enter", "maximize"),
    rectangle("m", "maximize"),
    rectangle("o", "restore"),

    rectangle("n", "next-display"),
    rectangle("p", "previous-display"),
  ]),

  ...createVimLayer(),

  createLayer("f").manipulators(finderLayer),

  createLayer("w").manipulators([
    map("h").to$("open -g hammerspoon://focusLeft"),
    map("j").to$("open -g hammerspoon://focusDown"),
    map("k").to$("open -g hammerspoon://focusUp"),
    map("l").to$("open -g hammerspoon://focusRight"),
    map("n").to$("open -g hammerspoon://focusNextMonitor"),
    map("p").to$("open -g hammerspoon://focusPreviousMonitor"),
  ]),

  rule(
    "Chrome: Change ctrl+np to arrow keys",
    ifApp(["Chrome", "slack"])
  ).manipulators([
    map("n", "left_control").to("down_arrow"),
    map("p", "left_control").to("up_arrow"),

    map("o", "left_control").to("[", "left_command"),
    map("i", "left_control").to("]", "left_command"),
  ]),

  rule(
    "Chrome: improve new tab vimium behaviour",
    ifApp("Chrome")
  ).manipulators([
    map("t", "command").to([
      { key_code: "t" },
      { key_code: "vk_none", hold_down_milliseconds: 100 },
      {
        key_code: "l",
        modifiers: ["command"],
      },
      { key_code: "delete_or_backspace" },
    ]),
  ]),

  rule("Disable hide and minimise").manipulators([
    map("m", "command").toNone(),
    map("h", "command").toNone(),
    map("return_or_enter", "command").toNone(),
  ]),
];

writeToProfile({ name: "Default profile" }, rules);
