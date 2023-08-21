import '@/styles/globals.css'
import type { AppProps } from 'next/app'
import Head from "next/head";
import 'bootstrap/dist/css/bootstrap.css'
import CustomNavbar from '../components/customNavbar';
import { Inter } from 'next/font/google'
import Footer from '@/components/customFooter';
const inter = Inter({ subsets: ['latin'] })

export default function App({ Component, pageProps }: AppProps) {
  return (
    <>
      <Head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </Head>
      <CustomNavbar/>
        <main className={`flex flex-col items-center pt-32 px-8 ${inter.className}`}>
          <Component {...pageProps} />
        </main>
      <Footer/>  
    </>
  )
}
