class RepositoriesController < ApplicationController
  # initialize HTTParty
  include HTTParty

  def create_repository
    personal_token = params[:personal_token]
    repository_name = params[:repository_name]
    user_name = params[:user_name]
    description = params[:description]

    if personal_token and repository_name and user_name
      response = create(personal_token, repository_name, user_name, description)
      if response and response.code == 201
        render json: { message: "Repository created", url: response["html_url"] }, status: :created
      else
        render json: { error: "Repository not created" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Missing params" }, status: :unprocessable_entity
    end
  end

  def delete_repository
    personal_token = params[:personal_token]
    repository_name = params[:repository_name]
    user_name = params[:user_name]

    if personal_token and repository_name and user_name
      response = delete(personal_token, repository_name, user_name)
      if response and response.code == 204
        render json: { message: "Repository deleted" }, status: :ok
      else
        render json: { error: "Repository not deleted" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Missing params" }, status: :unprocessable_entity
    end
  end

  def get_repository
    personal_token = params[:personal_token]
    repository_name = params[:repository_name]
    user_name = params[:user_name]

    if personal_token and repository_name and user_name
      response = get(personal_token, repository_name, user_name)
      if response and response.code == 200
        render json: { message: "Repository found", url: response["html_url"] }, status: :ok
      else
        render json: { error: "Repository not found" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Missing params" }, status: :unprocessable_entity
    end
  end

  def create_organization_repository
    personal_token = params[:personal_token]
    repository_name = params[:repository_name]
    organization_name = params[:organization_name]
    description = params[:description]

    if personal_token and repository_name and organization_name
      response = create_organization(personal_token, repository_name, organization_name, description)
      if response and response.code == 201
        render json: { message: "Repository created", url: response["html_url"] }, status: :created
      else
        render json: { error: "Repository not created" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Missing params" }, status: :unprocessable_entity
    end
  end

  def delete_organization_repository
    personal_token = params[:personal_token]
    repository_name = params[:repository_name]
    organization_name = params[:organization_name]

    if personal_token and repository_name and organization_name
      response = delete_organization(personal_token, repository_name, organization_name)
      if response and response.code == 204
        render json: { message: "Repository deleted" }, status: :ok
      else
        render json: { error: "Repository not deleted" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Missing params" }, status: :unprocessable_entity
    end
  end

  def get_organization_repository
    personal_token = params[:personal_token]
    repository_name = params[:repository_name]
    organization_name = params[:organization_name]

    if personal_token and repository_name and organization_name
      response = get_organization(personal_token, repository_name, organization_name)
      if response and response.code == 200
        render json: { message: "Repository found", url: response["html_url"] }, status: :ok
      else
        render json: { error: "Repository not found" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Missing params" }, status: :unprocessable_entity
    end
  end

  def upload_project_to_repository
    local_path = "/Users/adialexiu/Desktop/"
    personal_token = params[:personal_token]
    repository_name = params[:repository_name]
    application_name = params[:application_name]
    user_name = params[:user_name]
    commit_message = "Initial commit"

    local_path_with_app = "#{local_path}cmd_results/#{application_name}"

    if personal_token and repository_name and user_name
      response = upload(local_path_with_app, local_path, personal_token, repository_name, user_name, commit_message)
    end
  end

  private

  def create(personal_token, repo_name, _user, description)
    url = "https://api.github.com/user/repos"
    options = {
      body: {
        name: repo_name,
        description: description,
        private: false,
      }.to_json,
      headers: {
        'Authorization': "token #{personal_token}",
        'User-Agent': "HTTParty",
        'Content-Type': "application/json",
      },
    }
    response = HTTParty.post(url, options)
    return response
  end

  def delete(personal_token, repo_name, user)
    url = "https://api.github.com/repos/#{user}/#{repo_name}"
    options = {
      headers: {
        'Authorization': "token #{personal_token}",
        'User-Agent': "HTTParty",
        'Content-Type': "application/json",
      },
    }
    response = HTTParty.delete(url, options)
    return response
  end

  def get(personal_token, repo_name, user)
    url = "https://api.github.com/repos/#{user}/#{repo_name}"
    options = {
      headers: {
        'Authorization': "token #{personal_token}",
        'User-Agent': "HTTParty",
        'Content-Type': "application/json",
      },
    }
    response = HTTParty.get(url, options)
    return response
  end

  def create_organization(personal_token, repo_name, organization, description)
    url = "https://api.github.com/orgs/#{organization}/repos"
    options = {
      body: {
        name: repo_name,
        description: description,
        private: false,
      }.to_json,
      headers: {
        'Authorization': "token #{personal_token}",
        'User-Agent': "HTTParty",
        'Content-Type': "application/json",
      },
    }
    response = HTTParty.post(url, options)
    return response
  end

  def delete_organization(personal_token, repo_name, organization)
    url = "https://api.github.com/repos/#{organization}/#{repo_name}"
    options = {
      headers: {
        'Authorization': "token #{personal_token}",
        'User-Agent': "HTTParty",
        'Content-Type': "application/json",
      },
    }
    response = HTTParty.delete(url, options)
    return response
  end

  def get_organization(personal_token, repo_name, organization)
    url = "https://api.github.com/repos/#{organization}/#{repo_name}"
    options = {
      headers: {
        'Authorization': "token #{personal_token}",
        'User-Agent': "HTTParty",
        'Content-Type': "application/json",
      },
    }
    response = HTTParty.get(url, options)
    return response
  end

  def upload(local_path, path, personal_token, repo_name, user, commit_message)
    url = "https://#{personal_token}@github.com/#{user}/#{repo_name}.git"
    commands = []
    # Command 1
    command1 = "git init"
    commands << command1
    # Command 2
    command2 = "git add ."
    commands << command2
    # Command 3
    command3 = "git commit -m '#{commit_message}'"
    commands << command3
    # Command 4
    command4 = "git branch -M main"
    commands << command4
    # Command 5
    command5 = "git remote add origin #{url}"
    commands << command5
    # Command 6
    command6 = "git push -u origin main"
    commands << command6

    timestamp = Time.now.to_i
    run_commands(commands, local_path, path, nil)
  end

  def run_commands(commands, final_path, path, timestamp)
    RunCommand.perform_async(commands, final_path, path, nil)
  end
end
