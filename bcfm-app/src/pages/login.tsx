import { Button } from 'react-bootstrap';
import Card from 'react-bootstrap/Card';
import Form from 'react-bootstrap/Form';
import InputGroup from 'react-bootstrap/InputGroup';

export default function Page2() {
  return (
    <>
     <Card border="success" className='w-sm-100'>
        
        <Card.Body>
          <Card.Title>Log In</Card.Title>
          <hr className='w-100'></hr>
          <InputGroup className="mb-3">
          <div className='flex flex-col'>
            <div className="flex flex-row">
                <InputGroup.Text id="inputGroup-user">
                  User
                </InputGroup.Text>
                <Form.Control
                  aria-label="User"
                  aria-describedby="inputGroup-user"/>
            </div>
            <div className="flex flex-row mt-4">
            <InputGroup.Text id="inputGroup-pass">
                  Password
                </InputGroup.Text>
                <Form.Control
                  aria-label="Password"
                  aria-describedby="inputGroup-pass"/>
            </div>
          </div>
        </InputGroup>
        </Card.Body>
        <Card.Footer className="text-muted">
        <div className='flex flex-col items-center'>
          <Button className='btn-success'>Log In</Button>
          <div className='flex flex-row'>
            <p className='mt-3'>Not registered?</p>
            <Button className='btn-link'>Register here</Button>
          </div>
        </div>
        </Card.Footer>
      </Card></>
  )
}
