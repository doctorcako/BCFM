import Carousel from 'react-bootstrap/Carousel';

function HomeCarrousel() {
  return (
    <Carousel data-bs-theme="dark" className='border-dark border-5'>
      <Carousel.Item>
        <img
          className="d-block w-100"
          src="https://www.hexaengineers.us/wp-content/uploads/2019/05/Blog3.jpeg"
          alt="traceability_img"
        />
        <Carousel.Caption>
            <p className='font-bold italic bg-light p-1'>Traceability of farming processes thanks to Blockchain Technology and Internet of Things (IoT).</p>
        </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        <img
          className="d-block w-100"
          src="https://www.innominds.com/hubfs/Innominds-201612/img/IM-News-and-Blogs/Innominds-Solution-for-Precision-Agriculture.jpg"
          alt="sustainable_img"
        />
        <Carousel.Caption>
            <p className='font-bold italic bg-light p-1'>Sustainable and ecofriendly farming processes solution.</p>
        </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        <img
          className="d-block w-100"
          src="https://web.ua.es/es/gabinete-imagen/imagenes/logo-ua-color-centrado_medi.png"
          alt="ua_img"
        />
        <Carousel.Caption>
            <p className='font-bold italic bg-dark text-light'>A research technology from the University of Alicante</p>
        </Carousel.Caption>
      </Carousel.Item>
    </Carousel>
  );
}

export default HomeCarrousel;