import http from 'k6/http';

export const options = {
  scenarios: {
    load_test: {
      executor: 'constant-arrival-rate',
      rate: 2000,
      timeUnit: '1s',
      duration: '10m',
      preAllocatedVUs: 20000,
    },
  },
};

export default function () {
  // const url = 'http://localhost:8888/projects';
  const url = 'http://app/projects';
  const payload = JSON.stringify({ Name: 'test' });
  const headers = { 'Content-Type': 'application/json' };

  http.post(url, payload, { headers });
}
