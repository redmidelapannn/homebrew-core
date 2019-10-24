class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"

  url "https://github.com/hasura/graphql-engine/archive/v1.0.0-beta.8.tar.gz"
  sha256 "8daee3442b4ced4c9507fe14db324145cf0b7ad0a6c2ea7b78747dc8bef9c387"

  head "https://github.com/hasura/graphql-engine.git"

  depends_on "go" => :build

  def install
    Dir.chdir("cli")
    modname = "github.com/hasura/graphql-engine/cli"
    exflags = '-extldflags "-static"'
    ldflags = "-ldflags '-X #{modname}/version.BuildVersion=#{version} -s -w #{exflags}'"
    File.open("build.sh", "w") do |file|
      # Using a build file to work around an odd string interpolation issue with the single/double quotes
      file.puts "set -eox pipefail"
      file.puts "go mod init #{modname}"
      file.puts "go build -o ./bin/hasura -a -v #{ldflags} ./cmd/hasura/"
    end
    chmod "+x", "build.sh"
    system "./build.sh"
    bin.install "./bin/hasura"
  end

  test do
    assert_includes shell_output("#{bin}/hasura version").strip, "v#{version}"
  end
end
