import json

def test_ping(client):
    response = client.get('/')
    assert response.status_code == 200
    assert response.json['status'] == 'ready'



def test_unauthenticated_access(client):
  
    response = client.get('/student/assignments', headers={})
    assert response.status_code == 401

    response = client.get('/teacher/assignments', headers={})
    assert response.status_code == 401

    response = client.get('/principal/assignments', headers={})
    assert response.status_code == 401

def test_unauthorized_student_access(client, h_principal, h_teacher_1):
    response = client.get('/student/assignments', headers=h_principal)
    assert response.status_code == 403

    response = client.get('/student/assignments', headers=h_teacher_1)
    assert response.status_code == 403

def test_unauthorized_teacher_access(client, h_principal, h_student_1):
    response = client.get('/teacher/assignments', headers=h_principal)
    assert response.status_code == 403

    response = client.get('/teacher/assignments', headers=h_student_1)
    assert response.status_code == 403

def test_unauthorized_principal_access(client, h_student_1, h_teacher_1):
    response = client.get('/principal/assignments', headers=h_student_1)
    assert response.status_code == 403

    response = client.get('/principal/assignments', headers=h_teacher_1)
    assert response.status_code == 403