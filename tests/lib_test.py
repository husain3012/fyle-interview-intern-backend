from core.libs import exceptions

def test_fyle_exception():
    try:
        raise exceptions.FyleError(500, 'test')
    except exceptions.FyleError as e:
        assert e.message == 'test'
        assert e.status_code == 500
        assert e.to_dict() == {'message': 'test'}