class ElixirLs < Formula
  desc "Language Server Protocol implementation for Elixir"
  homepage "https://github.com/JakeBecker/elixir-ls"
  url "https://github.com/JakeBecker/elixir-ls/archive/v0.2.25.tar.gz"
  sha256 "48aef4a0e795627962bde7e9c5a4fd201f92ef816fc823738d6a1702ee911ee0"

  depends_on "elixir" => :build
  depends_on "erlang" => :build

  def install
    # Ensure Hex and Rebar3 are installed
    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"

    system "mix", "deps.get"
    system "mix", "compile"

    system "mix", "elixir_ls.release", "-o", prefix

    # Fix the launcher script
    # it depends on being in the same directory as .ez files
    bin.mkpath
    (bin/"elixir-ls").write <<~EOF
      #!/bin/sh

      export ERL_LIBS=#{prefix}:$ERL_LIBS
      elixir -e "ElixirLS.LanguageServer.CLI.main()"
    EOF
    chmod("+x", bin/"elixir-ls")
  end

  test do
    require "Open3"

    begin
      stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/elixir-ls")
      pid = wait_thr.pid
      stdin.write <<~EOF
        Content-Length: 58
        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Length", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
