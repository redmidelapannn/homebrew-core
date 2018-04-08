class Muttils < Formula
  desc "Provides utilities for use with console mail clients, eg. Mutt"
  homepage "https://bitbucket.org/blacktrash/muttils/"
  url "https://bitbucket.org/blacktrash/muttils/get/1.3.tar.gz"
  sha256 "c8b456b660461441de8927ccff7e9f444894d6550d0777ed7bd160b8f9caddbf"
  head "https://bitbucket.org/blacktrash/muttils", :using => :hg

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "debc7a7c47071097852f59fb53fd253f76fe17896420137eb0f9090a61a1f307" => :high_sierra
    sha256 "debc7a7c47071097852f59fb53fd253f76fe17896420137eb0f9090a61a1f307" => :sierra
    sha256 "debc7a7c47071097852f59fb53fd253f76fe17896420137eb0f9090a61a1f307" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match /^foo\nbar\n$/, pipe_output("#{bin}/wrap -w 2", "foo bar")
  end
end
