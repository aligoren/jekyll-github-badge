require 'net/http'
require 'json'

# url = 'https://api.github.com/repos/aligoren/gofret'
# uri = URI(url)

# response = Net::HTTP.get(uri)
# vars = JSON.parse(response)

module Jekyll
    class GitRepo < Liquid::Tag
        
        def initialize(tag_name, user_repo, tokens)
            super
            @user_repo = user_repo.strip
        end

        def render(context)
            if @user_repo
                
                begin
                    url = "https://api.github.com/repos/#{@user_repo}"
                    uri = URI(url)
                    response = Net::HTTP.get(uri)
                    
                    extract = JSON.parse(response)

                    if extract["message"] == "Not Found"
                        err_msg = "Project "+ extract["message"]
                        puts "\033[41m#{err_msg}\033[0m"
                    else
                        repo_return = %(<div class=\"card card-block\">)
                        repo_return += %(<p class=\"card-text\"><b>Project Details: </b>#{extract["name"]}</p>)
                        repo_return += %(<p class=\"card-text\"><b>Description: </b>#{extract["description"]}</p>)
                        repo_return += %(<table class=\"table table-sm\">)
                        repo_return += %(<tbody>)

                        repo_return += %(<tr>) 
                        repo_return += %(<th scope=\"row\">Project Name</th>) 
                        repo_return += %(<td><a class=\"card-link\" href=\"#{extract["html_url"]}\" target=\"_blank\">#{extract["name"]}</a></td>)
                        repo_return += %(</tr>)

                        repo_return += %(<tr>) 
                        repo_return += %(<th scope=\"row\">Author</th>) 
                        repo_return += %(<td><a class=\"card-link\" href=\"https://github.com/#{extract["owner"]["login"]}\" target=\"_blank\">#{extract["owner"]["login"]}</a></td>)
                        repo_return += %(</tr>)

                        repo_return += %(<tr>) 
                        repo_return += %(<th scope=\"row\">Programming Language</th>) 
                        repo_return += %(<td>#{extract["language"]}</td>)
                        repo_return += %(</tr>)

                        repo_return += %(<tr>) 
                        repo_return += %(<th scope=\"row\">Stargazers</th>) 
                        repo_return += %(<td>#{extract["stargazers_count"]}</td>)
                        repo_return += %(</tr>)

                        repo_return += %(<tr>) 
                        repo_return += %(<th scope=\"row\">Forks</th>) 
                        repo_return += %(<td>#{extract["forks_count"]}</td>)
                        repo_return += %(</tr>)
                        repo_return += %(</tbody>)
                        repo_return += %(</table>)
                        #https://github.com/aligoren/gofret/archive/master.zip
                        repo_return += %(<a href=\"#{extract["html_url"]}/archive/master.zip\" class=\"btn btn-primary\" target=\"_blank\">Download</a>)
                        repo_return += %(</div>)

                        return repo_return
                    end
                rescue NoMethodError
                    err_msg = "\nGithub API Error: API rate limit exceeded for your IP adress"
                    puts "\033[41m#{err_msg}\033[0m"
                end

                #return %(<span>Hello World #{url}</span>)
            else
                return %(Hata)
            end
        end
    end
end
Liquid::Template.register_tag('gitrepo', Jekyll::GitRepo)