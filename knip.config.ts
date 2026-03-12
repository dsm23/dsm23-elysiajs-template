import type { KnipConfig } from "knip";

const config: KnipConfig = {
  tags: ["-knipignore"],
  entry: ["src/**/*.d.ts"],
  playwright: {
    config: ["playwright.config.ts", "playwright.prod.config.ts"],
    entry: ["**/playwright-tests/*.@(spec|test).?(c|m)[jt]s?(x)"],
  },
  typescript: {
    config: ["tsconfig.json"],
  },
};

export default config;
