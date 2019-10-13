class Statik < Formula
  include Language::Python::Virtualenv

  desc "Python-based, generic static web site generator aimed at developers"
  homepage "https://getstatik.com"
  url "https://github.com/thanethomson/statik/archive/v0.22.2.tar.gz"
  sha256 "27aeda86c40ba2a489d2d8e85b7b38200e8f5763310003294c135ab2cf09975b"
  revision 1
  head "https://github.com/thanethomson/statik.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "daedee4b759903ba654ea3c06d401d890e05e0eb145e5e723b07017cfbb6c8b2" => :catalina
    sha256 "c51cb499af6cc9f177774d9d0ebe41bdffe184008d8cc829904009c8280cbd59" => :mojave
    sha256 "1ea9df8247069250b8c5f5280d33a89c6505ea70dc3320664171e1291a47de1b" => :high_sierra
  end

  depends_on "python"

  conflicts_with "go-statik", :because => "both install `statik` binaries"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "statik"
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"config.yml").write <<~EOS
      project-name: Homebrew Test
      base-path: /
    EOS
    (testpath/"models/Post.yml").write("title: String")
    (testpath/"data/Post/test-post1.yml").write("title: Test post 1")
    (testpath/"data/Post/test-post2.yml").write("title: Test post 2")
    (testpath/"views/posts.yml").write <<~EOS
      path:
        template: /{{ post.pk }}/
        for-each:
          post: session.query(Post).all()
      template: post
    EOS
    (testpath/"views/home.yml").write <<~EOS
      path: /
      template: home
    EOS
    (testpath/"templates/home.html").write <<~EOS
      <html>
      <head><title>Home</title></head>
      <body>Hello world!</body>
      </html>
    EOS
    (testpath/"templates/post.html").write <<~EOS
      <html>
      <head><title>Post</title></head>
      <body>{{ post.title }}</body>
      </html>
    EOS
    system bin/"statik"

    assert_predicate testpath/"public/index.html", :exist?, "home view was not correctly generated!"
    assert_predicate testpath/"public/test-post1/index.html", :exist?, "test-post1 was not correctly generated!"
    assert_predicate testpath/"public/test-post2/index.html", :exist?, "test-post2 was not correctly generated!"
  end
end
