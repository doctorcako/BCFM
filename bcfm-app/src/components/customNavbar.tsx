import Container from 'react-bootstrap/Container';
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import { Button } from 'react-bootstrap';
import Link from 'next/link';

export default function CustomNavbar() {
  return (
    <>
      <Navbar className="bg-body-tertiary border-bottom border-success" expand="lg" fixed="top" collapseOnSelect>
        <Container>
          <img
            alt=""
            src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUId4lklsFHpaJ8UlTvDoeY-P70xNdu8WgPthEMlLQ--NRjVBeBA1usxHda4AvqNWzy_A&usqp=CAU"
            width="90"
            height="90"
            className="d-inline-block align-top"
          />
          <Navbar.Brand href="/" className='mx-4'>BCFM</Navbar.Brand>
          
          <Navbar.Toggle />
          <Navbar.Collapse className="justify-content-center">
            <Nav className="me-auto ml-3 mt-2">
              <Nav.Link href="/">Manage</Nav.Link>
              <Nav.Link href="/">Project</Nav.Link>
              <Nav.Link href="#features">Work with us</Nav.Link>
              <Nav.Link href="#pricing">About us</Nav.Link>
            </Nav>
            <Navbar.Text>
              <Link href={"/login"}><Button className='btn btn-success mx-1 ml-2'>Log In</Button></Link>
            </Navbar.Text>
            <Navbar.Text>
              <Button className="btn btn-secondary mx-1">Sign Up</Button>
            </Navbar.Text>
          </Navbar.Collapse>
        </Container>
      </Navbar>
    </>
    
  );
}

