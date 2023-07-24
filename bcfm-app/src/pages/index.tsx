import { Inter } from 'next/font/google'
import HomeCarrousel from '@/components/homeCarrousel'
import HomeDescription from '@/components/homeDescription'
const inter = Inter({ subsets: ['latin'] })

export default function Home() {
  return (
    <>
      <h1 className='font-bold underline mb-5'>Blockchain Farm Manager</h1>
      <div className='col-sm-6'>
        <HomeCarrousel/>
      </div>
      <hr className='mt-5 w-100'></hr>
      <HomeDescription/>
    </>
  )
}
