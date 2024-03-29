require "rails_helper"
describe "get /v1/users/:uniqname/loans", type: :request do
  context "unauthorized request" do
    it "shows a patron's loan history" do
      loan = create(:loan)
      get "/v1/users/#{loan.user_uniqname}/loans"
      expect(response).to have_http_status(:unauthorized)
    end
  end
  context "authorized requests" do
    before(:each) do
      authorize
    end
    it "shows a patron's loan history" do
      loan = create(:loan)
      get "/v1/users/#{loan.user_uniqname}/loans"
      expect(response).to have_http_status(:success)
      expect(response.body).to include(loan.title)
    end
    it "returns appropriate response if user doesn't exist" do
      get "/v1/users/soandso/loans"
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq({error: "User not found"}.to_json)
    end
    it "does not create a patron if one doesn't exist" do
      get "/v1/users/soandso/loans"
      expect(User.count).to eq(0)
    end
    context "pagination params" do
      before(:each) do
        @user = create(:user)
        @loan1 = create(:loan, user: @user, checkout_date: 3.days.ago)
        @loan2 = create(:loan, user: @user, checkout_date: 1.day.ago)
      end
      it "works with limit" do
        get "/v1/users/#{@user.uniqname}/loans", params: {limit: 1}
        loans = JSON.parse(response.body)["loans"]
        expect(loans.count).to eq(1)
        expect(loans.first["title"]).to eq(@loan1.title)
      end
      it "works with offset" do
        get "/v1/users/#{@user.uniqname}/loans", params: {limit: 1, offset: 1}
        loans = JSON.parse(response.body)["loans"]
        expect(loans.count).to eq(1)
        expect(loans.first["title"]).to eq(@loan2.title)
      end
      it "handles sorting" do
        @loan1.update(title: "ZZZZ")
        @loan2.update(title: "AAAA")
        create(:loan, user: @user, title: "BBBB")
        get "/v1/users/#{@user.uniqname}/loans", params: {order_by: "title"}
        loans = JSON.parse(response.body)["loans"]
        expect(loans[0]["title"]).to eq("AAAA")
        expect(loans[1]["title"]).to eq("BBBB")
        expect(loans[2]["title"]).to eq("ZZZZ")
      end
    end
  end
end
describe "get /v1/users/:uniqname/loans/download" do
  before(:each) do
    authorize
  end
  context "csv" do
    it "returns a patrons full history as a csv download" do
      loan = create(:loan)
      get "/v1/users/#{loan.user_uniqname}/loans/download.csv"
      expect(response.body).to include("mms_id")
      expect(response.body).to include(loan.mms_id)
      expect(response.headers["Content-Type"]).to eq("text/csv")
      expect(response.headers["Content-Disposition"]).to include("filename=\"circulation_history_#{Date.today}.csv\"")
    end
    it "creates a new user if one doesn't exist" do
      get "/v1/users/soandso/loans/download.csv"
      expect(User.first.uniqname).to eq("soandso")
    end
  end
end
describe "get /v1/users/:uniqname" do
  context "unauthorized" do
    it "returns unauthorized" do
      user = create(:user, uniqname: "emcard")
      get "/v1/users/#{CGI.escape(user.uniqname)}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
  context "authorized" do
    before(:each) do
      authorize
    end
    it "handle patron with email address uniqname" do
      user = create(:user, uniqname: "so.and.so@example.com")
      get "/v1/users/#{CGI.escape(user.uniqname)}"
      expect(response).to have_http_status(:success)
    end
    it "shows a patron's loan retention status and confirmation status" do
      user = create(:user)
      get "/v1/users/#{user.uniqname}"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("retain_history")
      expect(response.body).to include("confirmed")
      expect(response.body).to include(user.uniqname)
    end
    it "creates a new user if one doesn't exist" do
      get "/v1/users/soandso"
      expect(User.count).to eq(0)
    end
  end
end
describe "put /v1/users/:uniqname {retain_history: false}" do
  context "authorized" do
    before(:each) do
      authorize
    end
    it "changes a patron's loan retention status and confirmation status and deletes existing loans; returns updated user" do
      user = create(:user, retain_history: true, confirmed: false)
      create(:loan, user: user)
      put "/v1/users/#{user.uniqname}", params: {retain_history: false}
      expect(response).to redirect_to("/v1/users/#{user.uniqname}")
      updated_user = User.first
      expect(updated_user.retain_history).to be_falsey
      expect(updated_user.confirmed).to be_truthy
      expect(Loan.all.count).to eq(0)
    end
    it "creates a user if one doesn't exist" do
      put "/v1/users/so_and_so", params: {retain_history: false}
      expect(response).to redirect_to("/v1/users/so_and_so")
      updated_user = User.first
      expect(updated_user.retain_history).to be_falsey
      expect(updated_user.confirmed).to be_truthy
      expect(Loan.all.count).to eq(0)
    end
  end
  context "unauthorized" do
    it "returns unauthorized" do
      user = create(:user, retain_history: true, confirmed: false)
      create(:loan, user: user)
      put "/v1/users/#{user.uniqname}", params: {retain_history: false}
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
