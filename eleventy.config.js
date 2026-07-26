import markdownIt from "markdown-it";
import { katex } from "@mdit/plugin-katex";

/** @param {import("@11ty/eleventy").UserConfig} eleventyConfig */
export default function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy({
    "node_modules/katex/dist/katex.min.css": "css/katex.min.css",
    "node_modules/katex/dist/fonts": "css/fonts",
  });

  const md = markdownIt({
    html: true,
    linkify: true,
    typographer: true,
  }).use(katex, {
    // HTML output + KaTeX CSS — best look for a math-heavy blog.
    output: "html",
    throwOnError: false,
  });
  eleventyConfig.setLibrary("md", md);

  eleventyConfig.addCollection("posts", (collectionApi) =>
    collectionApi.getFilteredByGlob("src/posts/*.md").sort((a, b) => b.date - a.date),
  );

  eleventyConfig.addFilter("readableDate", (date) => {
    if (!date) return "";
    return new Intl.DateTimeFormat("en-GB", {
      year: "numeric",
      month: "long",
      day: "numeric",
    }).format(date);
  });

  eleventyConfig.addFilter("isoDate", (date) => {
    if (!date) return "";
    return date.toISOString().slice(0, 10);
  });

  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
      data: "_data",
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    templateFormats: ["md", "njk", "html"],
  };
}
