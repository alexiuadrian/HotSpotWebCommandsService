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
end
