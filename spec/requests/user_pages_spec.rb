require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do

    before { visit signup_path }

    it { should have_selector "h2", "Sign Up" }
    it { should have_selector "form" }
  end

  describe "edit settings page" do
  end

  describe "profile/home page for signed in user" do
    let(:user) { FactoryGirl.create(:user)}
    before do 
      TaskList.create(name: "Default List", user_id: user.id)
      sign_in user
      visit user_path(user) 
    end

    it { should have_content user.username }
    it { should have_selector "form" }
    it { should have_link "Default List" }
  end

  describe "new task list page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path user
      fill_in "task_list_name", with: "new list"
      click_button "Create Task List"
    end

    it { should have_selector "div", text: "Task list was created." }
    it { should have_selector "h3", text: "new list" }
    it { should have_selector " form" }
    it { should have_selector "li", text: "Add tasks above" }

    describe "with added task" do
      before do 
        fill_in "task_task", with: "task 1"
        click_button "Create Task"
      end

      it { should have_selector "div.alert", text: "was added"}
      it { should have_selector "li", text: "task 1"}
      it { should have_link "check all" }
      it { should have_link "uncheck all" }

      describe "that is checked" do
        before { click_link "□" }

        it { should have_selector "div.alert", text: "completed"}
        it { should have_link "✓" }
        it { should have_link "Delete Completed" }

        describe "then unchecked" do
          before { click_link "✓" }

          it { should have_selector "div.alert", text: "updated"}
          it { should have_link "□" }
          it { should_not have_link "Delete Completed" }
        end
      end

      describe "click x" do
        before { click_link "×" }

        it { should have_selector "div.alert" }
        it { should_not have_selector "li", text: " task 1" }
        it { should have_selector "li", text: "Add tasks above" }
      end
    end

    describe "add several tasks" do
      before do
        5.times do |n|
          fill_in "task_task", with: "task #{n+1}"
          click_button "Create Task"
        end
      end

      it { should have_selector "div.alert" }
      it { should have_selector "li", text: "task 1" }
      it { should have_selector "li", text: "task 2" }
      it { should have_selector "li", text: "task 3" }
      it { should have_selector "li", text: "task 4" }
      it { should have_selector "li", text: "task 5" }

      describe "then click check all" do
        before { click_link "check all" }

        it { should have_selector "li", text: "✓" }

        describe "then click uncheck all link" do
          before { click_link "uncheck all" }

          it { should have_selector "li", text: "□" }
          it { should_not have_selector "li", text: "✓" }
          it { should_not have_link "Delete Completed"}
        end

        describe "then click delete button" do
          before { click_link "Delete Completed" }

          it { should have_selector "div.alert" }
          it { should have_selector "li", text: "Add tasks above" }
          it { should_not have_selector "li", text: "✓"}
          it { should_not have_selector "li", text: "□"}
        end
      end
    end
  end
end