class OssCli < Formula
  desc "Offline-first prompt intelligence workbench for open-source maintainers"
  homepage "https://github.com/ramanathan1504/oss-cli"
  url "https://github.com/ramanathan1504/oss-cli/releases/download/v1.5.1/oss-cli-1.5.1.jar"
  sha256 "084f7391d152707cba656711481be2482236846b23a9fb4bb594b80dc35eb380"
  license "Apache-2.0"

  depends_on "openjdk@17"

  def install
    # Derived from the URL, so a version bump means editing url + sha256 only.
    libexec.install File.basename(stable.url) => "oss-cli.jar"

    (bin/"oss-cli").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Formula["openjdk@17"].opt_prefix}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/oss-cli.jar" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Check everything is in place before you start:

        oss-cli doctor

      It reports every prerequisite at once -- model server, models, GitHub
      token, note folders -- with the exact command to fix anything missing.

      A model server is required. Ollama is the default:

        brew install ollama && ollama serve
        ollama pull all-minilm      # embeddings
        ollama pull llama3.2:3b     # local answers

      Then configure and sync:

        oss-cli setup
        oss-cli sync --all && oss-cli sync --me

      Upgrading from self-analyse or issue-ai? Your data is relocated
      automatically to ~/.oss-cli on first run.
    EOS
  end

  test do
    system "#{bin}/oss-cli", "--help"
  end
end
