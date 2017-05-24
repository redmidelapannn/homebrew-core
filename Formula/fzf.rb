require "language/go"

class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.16.7.tar.gz"
  sha256 "9676664e02393d19dd0f0a1ae4cf5d20e3fffcba666a0cffc40ff6c590c67760"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1fddb640b961dbbe2e973d7667f06e3aadc1cfe15b172d6e26c794f7b33c73d1" => :sierra
    sha256 "9659cce7ffd57085a236a35a6b35a0ec4c195e83e0491b04b16da1d8b94e1d9c" => :el_capitan
    sha256 "ccce999228f9f28773e2ae23e64b3e7693960456c2d6c53e71da20866fc90a80" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/junegunn/go-isatty" do
    url "https://github.com/junegunn/go-isatty.git",
        :revision => "66b8e73f3f5cda9f96b69efd03dd3d7fc4a5cdb8"
  end

  go_resource "github.com/junegunn/go-runewidth" do
    url "https://github.com/junegunn/go-runewidth.git",
        :revision => "14207d285c6c197daabb5c9793d63e7af9ab2d50"
  end

  go_resource "github.com/junegunn/go-shellwords" do
    url "https://github.com/junegunn/go-shellwords.git",
        :revision => "33bd8f1ebe16d6e5eb688cc885749a63059e9167"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "453249f01cfeb54c3d549ddb75ff152ca243f9d8"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/junegunn"
    ln_s buildpath, buildpath/"src/github.com/junegunn/fzf"
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"src/fzf" do
      system "go", "build"
      bin.install "fzf"
    end

    prefix.install %w[install uninstall LICENSE]
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  test do
    (testpath/"list").write %w[hello world].join($/)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end
