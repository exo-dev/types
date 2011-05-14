require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "FunctionController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Function.destroy_all }


  # GET /functions
  context ".index" do
    before { @uri = "/functions?page=1&per=100" }
    before { @resource = Factory(:function) }
    before { @not_owned_resource = Factory(:not_owned_function) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before { visit @uri }
      scenario "view all resources" do
        page.status_code.should == 200
        should_have_function(@resource)
        should_not_have_function(@not_owned_resource)
        should_have_valid_json(page.body)
        should_have_root_as('resources')
      end
    end
  end


  # GET /functions/{function-id}
  context ".show" do
    before { @resource = Factory(:function_complete) }
    before { @uri = "/functions/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_function) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view owned resource" do
        visit @uri
        page.status_code.should == 200
        should_have_function(@resource)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "rescued when not found", 
                            "visit @uri", "functions"
    end
  end


  ## POST /functions
  #context ".create" do
    #before { @uri =  "/functions/" }

    #it_should_behave_like "protected resource", "page.driver.post(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #let(:params) {{ 
        #name: Settings.type.name,
        #type_uri: Settings.type.uri 
      #}}

      #scenario "create resource" do
        #page.driver.post(@uri, params.to_json)
        #@resource = function.last
        #page.status_code.should == 201
        #should_have_function(@resource)
        #should_have_function_properties(@resource.function_properties)
        #should_have_function_functions(@resource.function_functions)
        #should_have_valid_json(page.body)
      #end

      #scenario "not valid params" do
        #page.driver.post(@uri, {}.to_json)
        #should_have_a_not_valid_resource
        #should_have_valid_json(page.body)
      #end
    #end
  #end


  ## PUT /functions/{function-id}
  ## TODO: Add a test when you update a function with another type 
  ## uri. Another solution is that type can not be updated, and 
  ## that in that case you probably want to create a new function.
  #context ".update" do
    #before { @resource = Factory(:function) }
    #before { @uri =  "/functions/#{@resource.id.as_json}" }
    #before { @not_owned_resource = Factory(:not_owned_function) }

    #it_should_behave_like "protected resource", "page.driver.put(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #let(:params) {{ 
        #name: "Set intensity updated",
        #type_uri: Settings.type.uri
      #}}

      #scenario "create resource" do
        #page.driver.put(@uri, params.to_json)
        #page.status_code.should == 200
        #should_have_function(@resource.reload)
        #page.should have_content "updated"
        #should_have_function_properties(@resource.function_properties)
        #should_have_function_functions(@resource.function_functions)
        #should_have_valid_json(page.body)
      #end

      #scenario "not valid params" do
        #params[:type_uri] = "not-an-uri"
        #page.driver.put(@uri, params.to_json)
        #should_have_a_not_valid_resource
      #end

      #it_should_behave_like "rescued when not found",
        #"page.driver.put(@uri)", "functions"
    #end
  #end


  ## DELETE /functions/{function-id}
  #context ".destroy" do
    #before { @resource = Factory(:function) }
    #before { @uri =  "/functions/#{@resource.id.as_json}" }
    #before { @not_owned_resource = Factory(:not_owned_function) }

    #it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #scenario "delete resource" do
        #lambda {
          #page.driver.delete(@uri, {}.to_json)
        #}.should change{ function.count }.by(-1)
        #page.status_code.should == 200
        #should_have_function(@resource)
        #should_have_valid_json(page.body)
      #end

      #it_should_behave_like "rescued when not found",
        #"page.driver.delete(@uri)", "functions"
    #end
  #end

end