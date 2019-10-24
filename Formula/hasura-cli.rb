class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"

  url "https://github.com/hasura/graphql-engine/archive/v1.0.0-beta.8.tar.gz"
  sha256 "8daee3442b4ced4c9507fe14db324145cf0b7ad0a6c2ea7b78747dc8bef9c387"

  head "https://github.com/hasura/graphql-engine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1027dcb0085e37e2b881502848d493562d79dbb73b6e952595c47074f659c83" => :catalina
    sha256 "3324b96b3d8f30aa343d0f75a9b0f807475abe8fa567a1a509dc8ab0b4f2f1ac" => :mojave
    sha256 "83705f97c7a1b33c227a9e25770ab274c3ec3008eeda0e165d12e444d836c6a1" => :high_sierra
  end

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
