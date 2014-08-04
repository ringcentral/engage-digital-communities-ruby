# encoding: utf-8

shared_examples_for 'common model actions' do

  before :each do
    @response = {'title' => 'new title'}.to_json
    @client = double
    allow(@client).to receive(:transport) { @response }
    @content = described_class.new({'id' => 123, 'title' => 'old title'}, @client)
    allow(@content).to receive(:errors) { [] }
  end

  %w(open close publish unpublish).each do |action|
    describe action do

      it 'sends a put to the appropriate uri' do
        path = @content.compute_path(@content.attributes) + "/#{action}"
        expect(@client).to receive(:transport).with(:put, path).and_return(@response)
        @content.send(action)
      end

      it 'updates the object with the new attributes' do
        expect {
          @content.send(action)
        }.to change { @content.title }.from('old title').to('new title')
      end

      it 'returns a boolean indicating any errors' do
        expect {
          allow(@content).to receive(:errors) { ['uh-oh'] }
        }.to change { @content.send(action) }.from(true).to(false)
      end

    end
  end

end
