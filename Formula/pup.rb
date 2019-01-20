class Pup < Formula
  desc "Parse HTML at the command-line"
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
  sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  head "https://github.com/EricChiang/pup.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "97f95ff019e311abb407d1ca4e4e4e0d6a3d8af8e342f86cdb1b795a9da300b2" => :mojave
    sha256 "9c228026a65c5b0e39d52628f29be9bfae5f7a54c09371b0140fcfe1773c242d" => :high_sierra
    sha256 "759c11014ebadea8e2ef285234a555810b54be2b3e31569c90a0313f278516aa" => :sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ericchiang/pup"
    dir.install buildpath.children

    cd dir do
      system "gox", "-arch", "amd64", "-os", "darwin", "./..."
      bin.install "pup_darwin_amd64" => "pup"
    end

    prefix.install_metafiles dir
  end

  test do
    output = pipe_output("#{bin}/pup p text{}", "<body><p>Hello</p></body>", 0)
    assert_equal "Hello", output.chomp
  end
end
