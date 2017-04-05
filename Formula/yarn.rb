class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.21.3/yarn-v0.21.3.tar.gz"
  sha256 "0946a4d1abc106c131b700cc31e5c3aa5f2205eb3bb9d17411f8115354a97d5d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "a7dc9e48571d37e0472c3471a41ae9daa6c86669dc2a7a343180d4e8c3d8454d" => :sierra
    sha256 "9c87745f7f08ef4ee6c1b68e44d43eb519f676ef951c0783060d556d7de0eab1" => :el_capitan
    sha256 "9c87745f7f08ef4ee6c1b68e44d43eb519f676ef951c0783060d556d7de0eab1" => :yosemite
  end

  depends_on "node"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/yarn.js" => "yarn"
    bin.install_symlink "#{libexec}/bin/yarn.js" => "yarnpkg"
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
