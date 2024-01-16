import requests, datetime, json

def post_sca_result(url, data, api_token):
    ''' Function that carries out the POST Http Request
        to the SCA service at the Vulnerability Management Platform
        in order to save them

    Args:
        url: url of the SAC service API.
        data: SCA result data in json format.
    Returns:
        An Exception or stdout message
    '''
    
    headers = {
        'Content-type': 'application/json',
        'Authorization': f'Token {api_token}'
    } if api_token != '' else {
        'Content-type': 'application/json',
    }
    
    data_json = json.loads(data)
    data_json["created_at"] = datetime.datetime.now().__str__()

    response = requests.post(url, headers=headers, data=json.dumps(data_json))

    if response.status_code != 201:
        raise Exception('Request failed with status code:', response.status_code)
    else:
        print('SCA Result successfully sent to the VMP ;)')
    