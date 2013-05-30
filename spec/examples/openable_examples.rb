# encoding: utf-8

shared_examples_for 'common model actions' do

  before :each do
    @response = {'title' => 'new title'}.to_json
    @client = double
    @client.stub(:transport) { @response }
    @content = described_class.new({'id' => 123, 'title' => 'old title'}, @client)
    @content.stub(:errors) { [] }
  end

  %w(open close publish unpublish).each do |action|
    describe action do

      it 'sends a put to the appropriate uri' do
        path = @content.compute_path(@content.attributes) + "/#{action}"
        @client.should_receive(:transport).with(:put, path).and_return(@response)
        @content.send(action)
      end

      it 'updates the object with the new attributes' do
        expect {
          @content.send(action)
        }.to change { @content.title }.from('old title').to('new title')
      end

      it 'returns a boolean indicating any errors' do
        expect {
          @content.stub(:errors) { ['uh-oh'] }
        }.to change { @content.send(action) }.from(true).to(false)
      end

    end
  end

end
