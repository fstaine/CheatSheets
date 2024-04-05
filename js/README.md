# JS

## Streams

Use stream as RxJS

Source: https://blog.erickwendel.com.br/reimagining-rxjs-using-web-streams?source=more_articles_bottom_blogs
```js
/**
 *
 * @param {EventTarget} target
 * @param {string} eventName
 * @returns {ReadableStream}
 */
const fromEvent = (target, eventName) => {
    let _listener;
    return new ReadableStream({
        start(controller) {
            _listener = (e) => controller.enqueue(e);
            target.addEventListener(eventName, _listener);
        },
        close() {
            target.event.removeEventListener(eventName, _listener);
        },
    });
};

/**
 * @typedef {function(): ReadableStream | TransformStream} StreamFunction
 *
 * @param {StreamFunction} fn
 * @param {object} options
 * @param {boolean} options.pairwise
 *
 * @return {TransformStream}
 */
const switchMap = (fn, options = { pairwise: true }) => {
    return new TransformStream({
        transform(chunk, controller) {
            const stream = fn.bind(fn)(chunk);
            const reader = (stream.readable || stream).getReader();

            async function read() {
                const { value, done } = await reader.read();
                if (done) {
                    return;
                }
                const result = options.pairwise ? [chunk, value] : value;
                controller.enqueue(result);
                return read();
            }

            // 3
            return read();
        },
    });
};

/**
 *
 * @param {ReadableStream | TransformStream} stream
 * @returns {TransformStream}
 */
const takeUntil = (stream) => {
    const readAndTerminate = async (stream, controller) => {
        const reader = (stream.readable || stream).getReader();
        const { value } = await reader.read();
        controller.enqueue(value);
        controller.terminate();
    };

    return new TransformStream({
        start(controller) {
            readAndTerminate(stream, controller);
        },
        transform(chunk, controller) {
            controller.enqueue(chunk);
        },
    });
};

/**
 *
 * @param {Function} fn
 * @return {TransformStream}
 */
const map = (fn) => {
    return new TransformStream({
        transform(chunk, controller) {
            controller.enqueue(fn.bind(fn)(chunk));
        },
    });
};

fromEvent(document.body, 'mousedown')
        .pipeThrough(
                switchMap(mouseDownEvent =>
                                fromEvent(document.body, 'mousemove')
                                        .pipeThrough(
                                                takeUntil(
                                                        fromEvent(document.body, 'mouseup')
                                                )
                                        ),
                        { pairwise: true }
                )
        )
        .pipeThrough(
                map(([mouseDown, mouseMove]) => {
                    return {
                        from: mouseDown.clientX,
                        to: mouseMove.clientX
                    }
                })
        )
        .pipeTo(
                new WritableStream({
                    write({ from, to}) {
                        console.log(
                                `you moved your mouse from ${from} to ${to}`
                        )
                    }
                })
        )
```
