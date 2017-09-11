describe Api::V1::CheckMailController, type: :controller do
  let(:valid_params) {
    {
        first_name: 'John',
        last_name: 'Snow',
        company_title: 'ralabs'
    }
  }
  context 'When params are invalid' do
    let(:invalid_params) { {} }
    let(:invalid_per_page) { valid_params.merge({ per_page: 'string' }) }
    let(:invalid_page) { valid_params.merge({ page: 'string' }) }
    it 'returns response with error' do
      get :index, params: invalid_params
      error_unprocessable_entity
    end

    it 'returns response with error when per page is a string' do
      get :index, params: invalid_per_page
      error_unprocessable_entity
    end

    it 'returns response with error when page is a string' do
      get :index, params: invalid_page
      error_unprocessable_entity
    end

    it 'returns response with error when first_name blank' do
      valid_params.delete(:first_name)
      get :index, params: valid_params
      error_unprocessable_entity
    end

    it 'returns response with error when last_name blank' do
      valid_params.delete(:last_name)
      get :index, params: valid_params
      error_unprocessable_entity
    end

    it 'returns response with error when company_title blank' do
      valid_params.delete(:company_title)
      get :index, params: valid_params
      error_unprocessable_entity
    end
  end

  context 'When params are valid' do
    it 'returns response with correct fields' do
      get :index, params: valid_params
      success_response
      expect(response_body['response']).to be_instance_of(Array)
    end

    it 'returns correct per page data' do
      get :index, params: valid_params.merge(per_page: 2)
      success_response
      expect(response_body['response'].size).to eq 2
    end
  end
end
