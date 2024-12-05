# Usage of `r-ollama`

## Prepare working environment
### Clone repository
Clone repository from github and get go to the directory. This examples uses an SSH approach to clone the repostory that requeries github authentication. However, there are different ways to do it.
```bash
$ cd ~
$ mkdir workspace
$ cd workspace
$ git clone git@github.com:renatosamperio/r-ollama.git
$ cd r-ollama
```

### Define working directory to be mounted
This step could be done in different ways. In the provided `docker-compose.yml` file, it is specified to mount a `volume` from a path to where this repo was cloned.
```yaml
    ...
    volumes:
      - "$HOME_PATH:/var/tmp"
```

You could define in such space your path or define the path in the variable called `HOME_PATH`. To do that, specify the path in a configuration file called `.env`.

```bash
$ echo "HOME_PATH=~/workspace/r-ollama" > .env
```
In this example, this repository was cloned in `~/workspace`.

### Pull image
Now pull example image from Docker registry by using configurtion file
```bash
$ docker compose pull r-ollama
```
The downloading might take some time depending on the size.

### Run container
Once the image would be downloaded, start it in a detached way with `docker compose`.
```bash
$ docker compose up -d r-ollama
```

### Execute container
Now, let's go inside the container.
```bash
$ docker exec -it r-ollama bash
root@b7f6afb8368c:/# 
```

## Work with ollama
### List existing models
```bash
root@b7f6afb8368c:/# ollama list
NAME                ID              SIZE      MODIFIED          
mathstral:latest    4ee7052be55a    4.1 GB    52 minutes ago       
mistral:latest      f974a74358d6    4.1 GB    58 minutes ago       
llava:latest        8dd30f6b0cb1    4.7 GB    About an hour ago    
sqlcoder:latest     77ac14348387    4.1 GB    About an hour ago    
llama3.2:latest     a80c4f17acd5    2.0 GB    About an hour ago    
root@b7f6afb8368c:/# 
```

### Verify any running model
Check if any model would be running.
```bash
root@b7f6afb8368c:/var/tmp/src/R# ollama ps
NAME    ID    SIZE    PROCESSOR    UNTIL 
root@b7f6afb8368c:/var/tmp/src/R#
```
In this example, it is not running anything.

### Run sample model
Let's run the listed model `llama3.2` and give it a prompt for testing along the command line.  
```bash
root@b7f6afb8368c:/var/tmp/src/R# ollama run llama3.2
>>> What is the capital of France?
The capital of France is Paris.

>>> 
root@b7f6afb8368c:/var/tmp/src/R#
```

## Run `R` examples
### Execute `R` console
Let's run an `R` console.
```bash
root@a50cc4ee0735:/# 
root@a50cc4ee0735:/var/tmp/src/R# R

R version 4.4.2 (2024-10-31) -- "Pile of Leaves"
Copyright (C) 2024 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> 
```

## Run LLM example package `ollamar`
This command works exactly the same as when it is calling the `ollama` CLI.
### Verify installed models
```r
> ollamar::list_models() 
              name   size parameter_size quantization_level            modified
1  llama3.2:latest   2 GB           3.2B             Q4_K_M 2024-12-01T14:44:39
2     llava:latest 4.7 GB             7B               Q4_0 2024-12-01T14:59:24
3 mathstral:latest 4.1 GB           7.2B               Q4_0 2024-12-01T15:12:25
4   mistral:latest 4.1 GB           7.2B               Q4_0 2024-12-01T15:05:48
5  sqlcoder:latest 4.1 GB             7B               Q4_0 2024-12-01T14:51:14
>
```

### Send prompts to local models
Use a trained model to get a response similar to `ollama` CLI prompt.
```r
> prompt <- "What is the capital of France?"
> tictoc::tic(msg = "Got response after")
> res <- ollamar::generate(model = "llama3.2", prompt = prompt, output = "text")
> tictoc::toc()
> print(res)
[1] "The capital of France is Paris."
```

Use a multi-model model to access images. For that, we can use model `llava`.
```r
> messages <- ollamar::create_message("What is in the image?", images = "lion.png")
> res <- ollamar::chat("llava", messages, output = "text")
> print(res)
[1] " The image features a majestic lion roaring against a backdrop of the sunset or sunrise. The lion appears to be in mid-roar, showcasing its powerful teeth and muscles. The setting suggests it's either early morning or late afternoon due to the warm lighting and colors present in the sky. "
```

## Run LLM example package `mall`
### Load library
```r
> library(mall)
>
```

### Load test data
This package comes with some example data about user's reviews.
```r
> data("reviews")
> reviews
                                                                              review
1                 This has been the best TV I've ever used. Great screen, and sound.
2          I regret buying this laptop. It is too slow and the keyboard is too noisy
3 Not sure how to feel about my new washing machine. Great color, but hard to figure
> 
```

### Execute model
In case model would be already install, the model is executed and request the model to use.
```r
> summary <- reviews |> mall::llm_summarize(review, max_words = 5)
Ollama local server running

1: Ollama - llama3.2:latest
2: Ollama - llava:latest
3: Ollama - mistral:latest
4: Ollama - sqlcoder:latest

Selection: 1
```
In this case, we want to use `llama:3.2` (option `1`). Then, the request would proceed.

```r
── mall session object 
Backend: Ollama
LLM session: model:llama3.2:latest
R session: cache_folder:/tmp/RtmpiLxFdf/_mall_cachea33ecaec39
> print(summary)
                                                                              review
1                 This has been the best TV I've ever used. Great screen, and sound.
2          I regret buying this laptop. It is too slow and the keyboard is too noisy
3 Not sure how to feel about my new washing machine. Great color, but hard to figure
                     .summary
1             it's a great tv
2 i regret my laptop purchase
3   unsure about the purchase
```

The classification example is as follows:

```r
> categories <- reviews |> mall::llm_classify(review, c("appliance", "computer"))
> print(categories)
                                                                              review
1                 This has been the best TV I've ever used. Great screen, and sound.
2          I regret buying this laptop. It is too slow and the keyboard is too noisy
3 Not sure how to feel about my new washing machine. Great color, but hard to figure
  .classify
1  computer
2  computer
3 appliance
```

Then, run a translation example.

```r
translation <- reviews |> mall::llm_translate(review, "spanish")
> print(translation)
                                                                              review
1                 This has been the best TV I've ever used. Great screen, and sound.
2          I regret buying this laptop. It is too slow and the keyboard is too noisy
3 Not sure how to feel about my new washing machine. Great color, but hard to figure
                                                                                       .translation
1                  Esta ha sido la mejor televisión que he utilizado. Pantalla y sonido excelentes.
2 Me arrepiento de haber comprado esta laptops. Es demasiado lento y la tecla es demasiado ruidosa.
3 No estoy seguro de cómo me siento con mi nuevo lavacorteza. Grande el color pero difícil entender
```

## Execute other examples
### Additional examples
The code was take from [here](https://cran.r-project.org/web/packages/ollamar/readme/README.html).
```bash
root@b7f6afb8368c:/var/tmp/src/R# Rscript reviews_core.R 
```

### Analise gene sequence
The code was taken from [here](https://www.r-bloggers.com/2024/08/use-r-to-prompt-a-local-llm-with-ollamar/).
```bash
root@b7f6afb8368c:/var/tmp/src/R# Rscript gene_sequence.R 
```