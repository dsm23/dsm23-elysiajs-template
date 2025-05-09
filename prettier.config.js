/**
 *  @type {import("prettier").Options}
 */
const config = {
  plugins: ["@ianvs/prettier-plugin-sort-imports"],
  importOrder: [
    "^elysia$",
    "<TYPES>^(elysia)",
    "<BUILTIN_MODULES>",
    "<TYPES>^(node:)",
    "<THIRD_PARTY_MODULES>",
    "<TYPES>^([@a-z])",
    "^~/(.*)$",
    "<TYPES>^~/(.*)",
    "^[.]",
    "<TYPES>",
  ],
  importOrderTypeScriptVersion: "5.8.3",
};

export default config;
