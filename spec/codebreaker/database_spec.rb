describe Database do
  describe '#existing_data' do
    subject { Database.existing_data }

    it 'return empty hash', scores_exist?: false do
      is_expected.to eq({})
    end

    it 'return empty hash', scores_exist?: true, scores_empty?: true do
      is_expected.to eq({})
    end

    it 'return unserialized scores', scores_exist?: true, scores_empty?: false do
      is_expected.to eq(scores_encoded)
    end
  end

  describe '#get_scores' do
    subject { Database.get_scores 'test' }

    it 'return nil', scores_exist?: false do
      is_expected.to eq(nil)
    end

    it 'return nil', scores_exist?: true, scores_empty?: true do
      is_expected.to eq(nil)
    end

    it 'return my scores', scores_exist?: true, scores_empty?: false do
      is_expected.to eq(scores_encoded['test'])
      is_expected.to be_kind_of(Array)
    end
  end

  describe '#save_result' do
    subject { Database.save_result('test', '') }
    it 'save player statictics', scores_empty?: true do
      expect {
        subject
      }.not_to change { File.exist? Database::DB_PATH } # test is mocking work
    end
  end
end
