class Svcat < Formula
  desc "Kubernetes Service Catalog CLI"
  homepage "https://github.com/Azure/service-catalog-cli"
  url "https://github.com/Azure/service-catalog-cli/archive/v0.2.1.tar.gz"
  sha256 "47d77c644f420f9889df6ef2851a24d32418f1eb7077ab09e2638e6e46e4079a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f256d0f1043ec32bae372b7b437d2aceb9211a99535735f54c8df307208cba00" => :high_sierra
    sha256 "41ae85627c537963759eb45b1bc4214f224e896efa4c3343ee11d41bce465bde" => :sierra
    sha256 "13d04b13e3af17d8c4e722fbf19056dc894e2973d4f35c72863e3ac38695495f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/Azure/service-catalog-cli").install buildpath.children

    cd "src/github.com/Azure/service-catalog-cli" do
      system "make", "build", "VERSION=#{version}"
      bin.install "bin/svcat"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/svcat", "version"
  end
end
