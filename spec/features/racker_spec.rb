feature 'Application' do
  let(:secret) { '1234' }

  before do
    allow_any_instance_of(Codebreaker::Game).to receive(:generate_secret)
      .with(4)
      .and_return(secret)
    test_scores = [{ attempts_number: 10, attempts_use: 0, time_taken: 14 }]
    allow(Database).to receive(:get_scores).and_return(test_scores)
    allow(Database).to receive(:save_result)
  end

  scenario 'login' do
    visit '/'
    expect(page).to have_current_path('/login')
    expect(page).to have_content 'Codebreaker'
    expect(Database).to receive(:get_scores) # mocks checking
    fill_in('Please, enter your name', with: 'test')
    click_button('Login')
    expect(page).to have_current_path('/?player_name=test')
    expect(page.driver.cookies['player_name']).to eq('test')
    expect(page).to have_content 'Attempts left: '
  end

  context 'main page when logged' do
    before do
      create_cookie 'player_name', 'test'
      visit '/'
    end

    scenario 'enter' do
      expect(page).to have_current_path('/')
      expect(page).to have_content 'Codebreaker'
      expect(find('ul.scores')).to have_selector('li.score', count: 1)
      expect_normal_playground
    end

    scenario 'win' do
      page.has_content? # wait for page to load # TODO find another way
      expect(Database).to receive(:save_result)
      guess(secret)
      expect_to_win
      expect(find('ul.scores')).to have_selector('li.score', count: 2)
      click_button('Restart')
      expect_normal_playground
    end

    scenario 'loose' do
      page.has_content? # wait for page to load # TODO find another way
      11.times { guess('1243') }
      expect(Database).not_to receive(:save_result)
      expect_to_loose
      expect(page).to have_css('.failure', count: 2)
      expect(find('ul.scores')).to have_selector('li.score', count: 1)
      click_button('Restart')
      expect_normal_playground
    end

    scenario 'wrong input' do
      page.has_content? # wait for page to load # TODO find another way
      guess('1239')
      expect_error
      guess('1111')
      expect(page).not_to have_selector('.error')
    end
  end
end
