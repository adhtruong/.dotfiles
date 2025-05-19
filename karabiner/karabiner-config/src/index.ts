import {
  FromKeyParam,
  ifApp,
  layer,
  map,
  rule,
  to$,
  writeToProfile,
  withModifier,
  mapDoubleTap,
  toApp,
  ModifierKeyCode,
  ToKeyParam,
} from "karabiner.ts";

function toLink(link: string, alias: string = "") {
  return to$(`~/bin/find-or-open-tab ${link} ${alias}`);
}

function mapToLink(key: FromKeyParam, link: string, alias: string = "") {
  return map(key).to(toLink(link, alias));
}

function rectangle(key: FromKeyParam, name: string) {
  return map(key).to$(`open -g rectangle://execute-action?name=${name}`);
}

const applicationModifiers = [
  map("h").toApp("Obsidian"),
  map("j").toApp("Google Chrome"),
  map("k").toApp("Ghostty"),
  mapDoubleTap("l")
    .delay(250)
    .toApp("Cursor")
    .singleTap(toApp("Visual Studio Code")),
  map(";").toApp("Slack"),

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

  mapDoubleTap("p")
    .delay(250)
    .to(
      to$("open raycast://extensions/degouville/cursor-recent-projects/index")
    )
    .singleTap(
      to$("open raycast://extensions/thomas/visual-studio-code/index")
    ),
];

writeToProfile({ name: "Default profile" }, [
  rule("Tap Caps Lock for ESC or Hold for Control").manipulators([
    map("caps_lock", "shift", "any").toIfAlone({
      key_code: "spacebar",
      modifiers: ["left_command"],
    }),
    map("caps_lock", "right_control").toIfAlone({
      key_code: "spacebar",
      modifiers: ["left_command"],
    }),

    map("caps_lock", null, "any")
      .to([{ key_code: "left_control", lazy: true }])
      .toIfAlone("escape"),

    map(";", "optionalAny")
      .toIfAlone(";", undefined, { halt: true })
      .toIfHeldDown("right_control", undefined, {})
      .parameters({
        "basic.to_if_held_down_threshold_milliseconds": 50,
      }),
  ]),

  layer("tab").manipulators([
    ...applicationModifiers,

    // Activate resizing layer
    map("w").toMeh(),
  ]),

  ...(["s", "e"] as const).map((key) =>
    layer(key)
      .modifiers("control")
      .configKey((v) => v.toIfAlone(key, "left_control"), false)
      .manipulators([...applicationModifiers])
  ),

  layer("r")
    .modifiers("control")
    .configKey((v) => v.toIfAlone("r", "left_control"), false)
    .manipulators([
      rectangle("j", "bottom-half"),
      rectangle("k", "top-half"),
      rectangle("h", "left-half"),
      rectangle("l", "right-half"),
      rectangle("return_or_enter", "maximize"),
      rectangle("o", "restore"),
    ]),

  layer("f")
    .modifiers("control")
    .configKey((v) => v.toIfAlone("f", "left_control"), false)
    .manipulators([
      map("j").to({ key_code: "tab", modifiers: ["right_command"] }),
      map("k").to({ key_code: "left_shift", modifiers: ["right_command"] }),

      map("l").to({
        key_code: "grave_accent_and_tilde",
        modifiers: ["right_command"],
      }),
      map("h").to({ key_code: "left_shift", modifiers: ["right_command"] }),

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

      mapDoubleTap("u")
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
    ]),

  rule("Resizing layer").manipulators([
    withModifier("Meh")([
      rectangle("j", "bottom-half"),
      rectangle("k", "top-half"),
      rectangle("h", "left-half"),
      rectangle("l", "right-half"),
      rectangle("return_or_enter", "maximize"),
      rectangle("o", "restore"),
    ]),
  ]),

  rule(
    "Chrome: Change ctrl+np to arrow keys",
    ifApp(["^com\\.google\\.Chrome", "^com\\.tinyspeck\\.slackmacgap"])
  ).manipulators([
    map("n", "left_control").to("down_arrow"),
    map("p", "left_control").to("up_arrow"),
  ]),

  rule(
    "Chrome: improve new tab vimium behaviour",
    ifApp(["^com\\.google\\.Chrome$"])
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
  ]),
]);
