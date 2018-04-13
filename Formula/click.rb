class Click < Formula
  desc "Command-Line Interactive Controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.3.2.tar.gz"
  sha256 "eed648409bf78a05658a9d097e5099ca17bf19df70122e2067859ae94c5575d5"
  head "https://github.com/databricks/click.git"

  bottle do
    sha256 "867d9a6452d961d05fbcdc69d2ca0355214227c0cea299da31aac7123e6ca183" => :high_sierra
    sha256 "c594e2db389db38dfe13ed35b342135ad2e6ae3346182592bd6416256b828a23" => :sierra
    sha256 "31a61f5b42673e86ba81c5198cf88752efbd88065271f4c65960f3851158bcdd" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/click"
  end

  test do
    system "#{bin}/click"
  end
end
