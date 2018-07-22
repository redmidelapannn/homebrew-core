HOMEBREW_ERD_GO_VERSION="1.4.1".freeze
class ErdGo < Formula
  desc "Translates plain text of RDB schema to entity-relationship diagram"
  homepage "https://github.com/kaishuu0123/erd-go"
  version HOMEBREW_ERD_GO_VERSION

  stable do
    url "https://github.com/kaishuu0123/erd-go/archive/v#{HOMEBREW_ERD_GO_VERSION}.tar.gz"
    sha256 "aa5b799f80391b7dec99a201b460d1858ee53cee1031753a5b1eb3eeb8611480"
  end
  bottle do
    cellar :any_skip_relocation
    sha256 "ffb0eb002a322d7ca2047d58d4395cbfc4f7a0a7eadd37e3bde697014aa1ab42" => :high_sierra
    sha256 "11dab024dc7cbdeaabc485ef8413d28a423dfd3f70824939139e3ccdc28ba555" => :sierra
    sha256 "266c22e19dfde5655a8215778050973c985b52718b0aba7259d69d0d85802e5c" => :el_capitan
  end


  head do
    url "https://github.com/kaishuu0123/erd-go.git"
  end

  devel do
    url "https://github.com/kaishuu0123/erd-go.git"
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "make" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    dir = buildpath/"src/github.com/kaishuu0123/erd-go"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "build_no_peg"
      cp "erd-go", buildpath
    end

    bin.install "erd-go"
    prefix.install_metafiles
  end

  test do
    assert_match "erd-go", shell_output("#{bin}/erd-go --help", 1)
  end
end
