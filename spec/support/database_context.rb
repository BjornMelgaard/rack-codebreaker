RSpec.shared_context 'scores_exist' do
  before do
    allow(File).to receive(:exist?).and_return(true)
  end
end

RSpec.shared_context 'scores_not_exist' do
  before do
    allow(File).to receive(:exist?).and_return(false)
  end
end

RSpec.shared_context 'scores_empty' do
  let(:scores) { '' }
  before do
    allow(File).to receive(:read).with('scores.yaml').and_return(scores)
    allow(File).to receive(:open).with('scores.yaml', 'w')
  end
end

RSpec.shared_context 'scores_not_empty' do
  let(:scores) { "---\ntest:\n- :attempts_number: 10\n  :attempts_used: 0\n  :time_taken: 14" }
  let(:scores_encoded) { YAML.load(scores) }
  before do
    allow(File).to receive(:read).with('scores.yaml').and_return(scores)
    allow(File).to receive(:open).with('scores.yaml', 'w')
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'scores_exist', scores_exist?: true
  rspec.include_context 'scores_not_exist', scores_exist?: false
  rspec.include_context 'scores_empty', scores_empty?: true
  rspec.include_context 'scores_not_empty', scores_empty?: false
end
