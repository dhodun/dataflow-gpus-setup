import argparse
import logging

import apache_beam as beam
import torch
from apache_beam.options.pipeline_options import PipelineOptions


def check_gpus(element, gpus_optional=False):
    # Make sure we have a GPU available.
    gpu_available = torch.cuda.is_available()
    if not gpu_available:
        if gpus_optional:
            logging.warning("No GPUs found, defaulting to CPU.")
        else:
            raise RuntimeError("No GPUs found.")
    else:
      logging.info(f'Using GPU: {torch.cuda.get_device_name(0)}')

    
    return element

def run(beam_args):
    options = PipelineOptions(beam_args, save_main_session=True)
    with beam.Pipeline(options=options) as pipeline:
        # validate that the workers are using GPUs.
        (
            pipeline
            | beam.Create([None])
            | "Check GPU availability" >> beam.Map(check_gpus)
        )

if __name__ == "__main__":
  logging.getLogger().setLevel(logging.INFO)

  parser = argparse.ArgumentParser()

  args, beam_args = parser.parse_known_args()

  run(beam_args)
