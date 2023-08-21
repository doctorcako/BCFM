import { Button } from 'react-bootstrap';
import Card from 'react-bootstrap/Card';
import Form from 'react-bootstrap/Form';
import InputGroup from 'react-bootstrap/InputGroup';

export default function Login() {
  return (
    <>
      <div className="w-100 m-8"></div>
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
          <div className='flex flex-col items-center mt-2'>
            <Button className='btn-success'>Log In</Button>
            <div className='flex flex-row mt-3'>
              <p className='mt-3 mr-2'>Not registered?</p>
              <Button variant="link">Register here</Button>
            </div>
          </div>
        </Card.Footer>
      </Card>
      <div className='mt-60'></div>
    </>
  )
}
