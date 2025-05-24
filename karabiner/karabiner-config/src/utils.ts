import { to$, FromKeyParam, map, ifVar } from "karabiner.ts";

function toLink(link: string, alias: string = "") {
  return to$(`~/bin/find-or-open-tab ${link} ${alias}`);
}

export function mapToLink(key: FromKeyParam, link: string, alias: string = "") {
  return map(key).to(toLink(link, alias));
}

export function rectangle(key: FromKeyParam, name: string) {
  return map(key).to$(`open -g rectangle://execute-action?name=${name}`);
}

export function ifLayer() {
  return ifVar("__layer", 1);
}
