version = `git describe --tags --abbrev=0`.gsub!("v", "")


Gem::Specification.new do |spec|
  spec.name = "eventline"
  spec.version = version
  spec.authors = ["Exograd SAS"]
  spec.email = ["support@exograd.com"]

  spec.summary = "Eventline Ruby SDK."
  spec.description = "Eventline is a scheduling platform where you can define and run " \
    "custom tasks in a safe environment."
  spec.homepage = "https://docs.eventline.net"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/exograd/rb-eventline/issues",
    "changelog_uri" => "https://github.com/exograd/rb-eventline/blob/master/CHANGELOG.md",
    "github_repo" => "ssh://github.com/exograd/rb-eventline",
    "homepage_uri" => "https://docs.eventline.net",
    "source_code_uri" => "https://github.com/exograd/rb-eventline"
  }

  spec.files = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]
end
