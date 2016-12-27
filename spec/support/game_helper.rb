require_relative 'wait_for_ajax'

module GameHelper
  def guess(code)
    page.execute_script %(
      $(".playground-form").find("input").each(function(index, item) {
        return $(item).val("#{code}".charAt(index));
      });
    )
    click_button('Submit')
    wait_for_ajax
  end

  def expect_normal_playground
    expect(page).to     have_selector('.attempts')
    expect(page).not_to have_selector('.win')
    expect(page).not_to have_selector('.loose')
    expect(page).not_to have_selector('.error')
    expect(page).to     have_selector('.btn-restart')
    expect(page).to     have_selector('.btn-guess')
    expect(page).to     have_selector('.code', count: 4)
  end

  def expect_to_win
    expect(page).to     have_css('.success', count: 4)
    expect(page).not_to have_css('.failure')
    expect(page).not_to have_selector('.attempts')
    expect(page).to     have_selector('.win')
    expect(page).not_to have_selector('.loose')
    expect(page).not_to have_selector('.error')
    expect(page).to     have_selector('.btn-restart')
    expect(page).not_to have_selector('.btn-guess')
  end

  def expect_to_loose
    expect(page).not_to have_selector('.attempts')
    expect(page).not_to have_selector('.win')
    expect(page).to     have_selector('.loose')
    expect(page).not_to have_selector('.error')
    expect(page).to     have_selector('.btn-restart')
    expect(page).not_to have_selector('.btn-guess')
    expect(page).to     have_content("You loose, secret code was #{secret}")
  end

  def expect_error
    expect(page).to     have_selector('.attempts')
    expect(page).not_to have_selector('.win')
    expect(page).not_to have_selector('.loose')
    expect(page).to     have_selector('.error')
    expect(page).to     have_selector('.btn-restart')
    expect(page).to     have_selector('.btn-guess')
    expect(page).to     have_content('Wrong input')
  end
end

RSpec.configure do |config|
  config.include GameHelper, type: :feature
end
