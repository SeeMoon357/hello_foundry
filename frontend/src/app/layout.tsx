import './globals.css'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import { type ReactNode } from 'react'
import { Providers } from './providers' // 指向我们刚才新建的 providers.tsx

const inter = Inter({ subsets: ['latin'] })

// 修改网页标题，更有仪式感
export const metadata: Metadata = {
  title: 'W-11K Bank DApp',
  description: 'Powered by Foundry & Next.js',
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      {/* className={inter.className} 让你的网页拥有漂亮的 Inter 字体 */}
      <body className={inter.className}>
        {/* 这里就是“包起来”：用我们的 Web3 环境包住所有页面内容 */}
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  )
}