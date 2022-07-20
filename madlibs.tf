# variable "nouns" {
#    description = "A list of nouns"
#    type = list(string)
# }

# variable "adjectives" {
#   description = "A list of adjectives"
#   type = list(string)
# }

# variable "verbs" {
#   description = "A list of verbs"
#   type = list(string)
# }   

# variable "numbers" {
#   description = "A list of numbers"
#   type = list(string)
# }

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    random = {
      source  = "HashiCorp/random"
      version = ">=3.0"
    }
  }
}

variable "words" {
  description = "A words pool to use for mad libs"
  type = object(
    {
      nouns      = list(string)
      adjectives = list(string)
      verbs      = list(string)
      numbers    = list(number)
      adverbs    = list(string)
    }
  )
  validation {
    condition     = length(var.words["nouns"]) >= 12
    error_message = "需要至少 20 个单词"
  }
}

resource "random_shuffle" "random_nouns" {
  input = var.words["nouns"]
}

resource "random_shuffle" "random_adjectives" {
  input = var.words["adjectives"]
}

resource "random_shuffle" "random_verbs" {
  input = var.words["verbs"]
}

resource "random_shuffle" "random_numbers" {
  input = var.words["numbers"]
}

resource "random_shuffle" "random_adverbs" {
  input = var.words["adverbs"]
}


output "mad_libs" {
  value = templatefile("${path.module}/templates/alice.txt",
    {
      nouns      = random_shuffle.random_nouns.result
      adjectives = random_shuffle.random_adjectives.result
      verbs      = random_shuffle.random_verbs.result
      adverbs    = random_shuffle.random_adverbs.result
      numbers    = random_shuffle.random_numbers.result
    }
  )
}
