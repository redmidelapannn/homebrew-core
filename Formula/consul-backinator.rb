class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator.git",
    :tag => "v1.0",
    :revision => "c07989a0cf4f18d4401d6975c48513ffa7db6d5d"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4c5932127e599e7c46ffe8241b3a47dd840e3aa4a30c8719b1474d2ac5ed3ab" => :el_capitan
    sha256 "00dc4748a927fd241ad3143fc9c3f89c622b6ce513802026c67ed193bde00d27" => :yosemite
    sha256 "29ea5d0e76e02ab61689b4de96d481788b085afb5d722deba491b3b8ffeeeea4" => :mavericks
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/myENA/consul-backinator"
    dir.install buildpath.children

    ENV.prepend_create_path "PATH", buildpath/"bin"

    cd dir do
      system "./build.sh", "-i"
      bin.install "consul-backinator"
    end
  end

  test do
    ## testing requires access consul
  end
end
