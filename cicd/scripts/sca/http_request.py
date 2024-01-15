import requests

def post_sca_result(url, data):
    ''' Function that carries out the POST Http Request
        to the SCA service at the Vulnerability Management Platform
        in order to save them

    Args:
        url: url of the SAC service API.
        data: SCA result data in json format.
    Returns:
        An Exception or stdout message
    '''
    
    headers = {'Content-type': 'application/json'}
    # data = '{"title": "foo", "body": "bar", "userId": 1}'

    response = requests.post(url, headers=headers, data=data)

    if response.status_code != 201:
        raise Exception('Request failed with status code:', response.status_code)
    else:
        print('SCA Result successfully sent to the VMP ;)')
        # print(response.json())
    