import { defineConfig } from 'vitepress'
import { groupIconVitePlugin, groupIconMdPlugin } from 'vitepress-plugin-group-icons'

// https://vitepress.dev/reference/site-config
export default defineConfig({
    title: "Allium",
    description: "The Lua script loader for Minecraft",
    lang: "en-US",
    head: [
        [
            'link',
            { rel: 'icon', type: 'image/png', href: 'icon.png' }
        ],
    ],
    base: "/allium-docs/",
    themeConfig: {
        logo: "/icon.png",
        // https://vitepress.dev/reference/default-theme-config
        nav: [
            { text: 'Home', link: '/' },
            { text: 'Reference', link: '/reference/fundamentals' },
        ],

        sidebar: [
            {
                text: 'Setup',
                items: [
                    { text: "Add Scripts", link: '/setup/add-scripts' },
                    { text: "Get Started", link: '/setup/get-started' },
                ]
            },
            {
                text: 'Guides',
                items: [
                    { text: "My First Script", link: "/guides/my-first-script" }
                ]
            },
            {
                text: 'Reference',
                items: [
                    { text: 'Fundamentals', link: '/reference/fundamentals' },
                    { text: 'Scripts', link: '/reference/scripts' },
                    { text: 'Package Library', link: '/reference/package-lib' },
                    { text: 'Java Library', link: '/reference/java-lib' },
                    { text: 'Mixin Library', link: '/reference/mixin-lib' },
                    { text: 'Class Building', link: '/reference/class-building' },
                    { text: 'Extensions', link: '/reference/extensions' },
                ]
            }
        ],

        socialLinks: [
            { icon: 'modrinth', link: 'https://modrinth.com/mod/allium' },
            { icon: 'github', link: 'https://github.com/moongardenmods/allium' },
            { icon: 'discord', link: "https://discord.gg/rWSaP222G9" },
        ]
    },

    markdown: {
        config(md) {
            md.use(groupIconMdPlugin, {
                titleBar: { includeSnippet: true },
            })
        },
        lineNumbers: true,
    },

    vite: {
        plugins: [
            groupIconVitePlugin({
                customIcon: {
                    'lua': "material-icon-theme:lua",
                    'java': "material-icon-theme:java"
                }
            })
        ]
    }
})
